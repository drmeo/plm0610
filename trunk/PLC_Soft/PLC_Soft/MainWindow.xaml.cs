using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using CommunicationCore.RS232;
using CommunicationCore.PLM;
using System.IO;
using System.IO.Ports;
using System.Threading;
using PLC_Soft.Properties;

namespace PLC_Soft
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window
	{
		private SerialPort serial = null;
		private string textToSend = "";
		private byte[] bytesToSend;
		private int maxLength;
		private string receiveMessage;
		private byte domainAdrress;
		private byte transmitAddress;
		private byte receiveAddress = 255;
		private byte controlByte = 0;
		private byte totalByte = 1;
		private byte currentByte = 1;
		private byte repetitionByte = 1;
		private byte command;
		private List<IPInformation> friendsList;
		private Thread broadcastThread = null;
		private IPInformation currentFriend;
		private bool stopNow = false;

		#region Constructror and Friend

		public MainWindow()
		{
			InitializeComponent();
			broadcastThread = new Thread(new ThreadStart(SendBroadCast));
			broadcastThread.IsBackground = false;
		}

		private void InitializeIPAddress()
		{
			try
			{
				domainAdrress = byte.Parse(Settings.Default.DomainAddress);
				transmitAddress = byte.Parse(Settings.Default.IPAddress);
			}
			catch (FormatException ex)
			{
				domainAdrress = 1;
				transmitAddress = 1;
			}
		}

		private void EnableControl()
		{
			btnSend.IsEnabled = true;
			txtMessage.IsEnabled = true;
			rtbChatContent.IsEnabled = true;
			listFriends.IsEnabled = true;
			lbInform.IsEnabled = true;
			lbInform.Content = "Friends list";
			friendsList = new List<IPInformation>();
			listFriends.ItemsSource = friendsList;
			IPInformation ip = new IPInformation();
			ip.FriendID = 1;
			ip.DomainID = 1;
			ip.LastBroadCast = DateTime.Now;
			friendsList.Add(ip);
		}

		private void InitializeControlValue()
		{

			try
			{
				maxLength = Settings.Default.MaxLength;
				if (serial == null)
					serial = new SerialPort();
				serial.BaudRate = Settings.Default.BaudRate;
				serial.DataBits = Settings.Default.DataBits;
				serial.Parity = Settings.Default.Parity;
				serial.StopBits = Settings.Default.StopBits;
				serial.PortName = Settings.Default.PortName;
				serial.WriteTimeout = 500;
				serial.ReadTimeout = 500;
				OpenPort();
				serial.DataReceived += new SerialDataReceivedEventHandler(serial_DataReceived);
				serial.ErrorReceived += new SerialErrorReceivedEventHandler(serial_ErrorReceived);
				MessageBox.Show(this, "Connect success.", "Connect success", MessageBoxButton.OK, MessageBoxImage.Information);
			}
			catch (IOException ex)
			{
				MessageBox.Show(this, "Cann't connect to device, Please check the connection or try to config RS232 communication and your device.", "Can't connect", MessageBoxButton.OK, MessageBoxImage.Error);
				stopNow = true;
			}
			Thread.Sleep(100);
		}


		#endregion

		#region Events

		void serial_ErrorReceived(object sender, SerialErrorReceivedEventArgs e)
		{
			MessageBox.Show(this, "The process has some problems", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
		}
		void serial_DataReceived(object sender, SerialDataReceivedEventArgs e)
		{
			Thread.Sleep(500);
			SerialPort serialPort = sender as SerialPort;
			byte[] buffer = null;
			// doc tu rs232
			buffer = RS232Task.ReadData(serialPort);
			// get command
			command = RS232Task.GetCommand(buffer);
			switch (command)
			{
				case ((byte)RS232Command.COM_GET_PLM):
					// kiem tra dieu kien IP
					if (PLMTask.CheckIP(buffer, domainAdrress, transmitAddress))
					{
						receiveMessage = RS232Task.GetDataFromPLM(buffer);
						rtbChatContent.Dispatcher.BeginInvoke(new Action(delegate()
						{
							rtbChatContent.AppendText("Friend: " + receiveMessage + "\n");
							rtbChatContent.ScrollToEnd();
						}));
					}
					break;
				case ((byte)RS232Command.COM_BROADCAST):
					if (PLMTask.IsBroadCastMessage(buffer, domainAdrress))
					{
						IPInformation newFriend = PLMTask.GetNewFriend(buffer);
						if (friendsList.Count == 0)
							friendsList.Add(newFriend);
						else
						{
							if (!IsContainFriend(newFriend))
							{
								friendsList.Add(newFriend);
							}
							else
							{
								foreach (var oldFriend in friendsList)
								{
									if (oldFriend.FriendID == newFriend.FriendID)
									{
										oldFriend.LastBroadCast = newFriend.LastBroadCast;
										break;
									}
								}
							}
						}
					}
					break;
			}
		}

		private void MenuItem_Click(object sender, RoutedEventArgs e)
		{
			var item = sender as MenuItem;
			switch (item.Header.ToString())
			{
				case "RS232 Config":
					new frmSerialPort().ShowDialog();
					break;
				case "PLM Config":
					new frmSTRegister(serial, broadcastThread).ShowDialog();
					break;
				case "IP Config":
					new frmIPConfig().ShowDialog();
					break;
				case "About":
					new About().ShowDialog();
					break;
				case "Help":
					new Help().ShowDialog();
					break;
				case "Connect":
					InitializeControlValue();

					if (!stopNow)
					{
						EnableControl();
						InitializeIPAddress();
						broadcastThread.Start();
					}
					break;
				case "Close":
					this.Close();
					break;
			}
		}
		/// <summary>
		/// Send data to RS232
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnSend_Click(object sender, RoutedEventArgs e)
		{
			SendMessage();
		}


		private void Window_KeyUp(object sender, KeyEventArgs e)
		{
			if (e.Key == Key.Enter)
				SendMessage();
		}

		private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
		{
			broadcastThread.Abort();
		}

		private void listFriends_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			currentFriend = (IPInformation)listFriends.SelectedItem;
			transmitAddress = currentFriend.FriendID;
			MessageBox.Show(transmitAddress.ToString());
		}
		#endregion



		#region Private Methods


		private void SendMessage()
		{
			textToSend = txtMessage.Text;
			if (textToSend != "")
			{
				bytesToSend = new byte[textToSend.Length];
				System.Text.ASCIIEncoding.ASCII.GetBytes(textToSend, 0, textToSend.Length, bytesToSend, 0);
				bytesToSend = PLMTask.DataPreProcessing(bytesToSend, domainAdrress, transmitAddress, receiveAddress, controlByte, totalByte, currentByte, repetitionByte);
				bytesToSend = RS232Task.AddHeaderInformation(bytesToSend, (byte)RS232Command.COM_HEADER, (byte)RS232Command.COM_SET_PLM);
				serial.Write(bytesToSend, 0, bytesToSend.Length);
				rtbChatContent.Dispatcher.BeginInvoke(new Action(delegate()
				{
					rtbChatContent.AppendText("You: " + textToSend + "\n");
					rtbChatContent.ScrollToEnd();
				}));
				txtMessage.Clear();
			}

		}

		private bool IsContainFriend(IPInformation nFriend)
		{
			foreach (var oldFriend in friendsList)
			{
				if (oldFriend.FriendID == nFriend.FriendID)
				{
					return true;
				}
			}
			return false;
		}

		/// <summary>
		/// Connect to RS232
		/// </summary>
		private void OpenPort()
		{
			if (!serial.IsOpen)
				serial.Open();
		}

		

		private void SendBroadCast()
		{
			while (1 == 1)
			{
				byte[] broadCastMess = new byte[0];
				broadCastMess = PLMTask.DataPreProcessing(broadCastMess, domainAdrress, transmitAddress, 255, controlByte, totalByte, currentByte, repetitionByte);
				broadCastMess = RS232Task.AddHeaderInformation(broadCastMess, (byte)RS232Command.COM_HEADER, (byte)RS232Command.COM_BROADCAST);
				serial.Write(broadCastMess, 0, broadCastMess.Length);
				Thread.Sleep(5 * 60 * 1000);
			}
		}
		#endregion






	}
}
