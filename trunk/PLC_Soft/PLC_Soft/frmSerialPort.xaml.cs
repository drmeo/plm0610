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
using System.Windows.Shapes;
using System.IO.Ports;
using PLC_Soft.Properties;

namespace PLC_Soft
{
	/// <summary>
	/// Interaction logic for frmSerialPort.xaml
	/// </summary>
	public partial class frmSerialPort : Window
	{
		private bool closeNow = false;
		private SerialPort serial;

		public frmSerialPort()
		{
			InitializeComponent();
			if (serial == null)
				serial = new SerialPort();
			InitializeControlValues();
			
		}

		private void InitializeControlValues()
		{
			//lay cac port serial tu he thong
			cmbCOMPort.Items.Clear();
			foreach (var portName in SerialPort.GetPortNames())
				cmbCOMPort.Items.Add(portName);

			if (cmbCOMPort.Items.Contains(Settings.Default.PortName))
				cmbCOMPort.Text = Settings.Default.PortName;
			else if (cmbCOMPort.Items.Count > 0)
				cmbCOMPort.SelectedIndex = 0;
			else
			{
				MessageBox.Show(this, "There are no COM Ports detected on this computer.\nPlease install a COM Port and restart this app.", "No COM Ports Installed", MessageBoxButton.OK, MessageBoxImage.Error);
				closeNow = true;
			}

			//lay baudrate tu he thong
			//lay parity tu he thong
			cmbParity.Items.Clear();
			foreach (var parityName in Enum.GetNames(typeof(Parity)))
				cmbParity.Items.Add(parityName);
			//lay databits tu he thong
			//lay stopbits tu he thong
			cmbStopBits.Items.Clear();
			foreach (var bitStopName in Enum.GetNames(typeof(StopBits)))
				cmbStopBits.Items.Add(bitStopName);

			cmbStopBits.Text = Settings.Default.StopBits.ToString();
			cmbDataBits.Text = Settings.Default.DataBits.ToString();
			cmbParity.Text = Settings.Default.Parity.ToString();
			cmbBaudrate.Text = Settings.Default.BaudRate.ToString();

		}

		private void btnCancel_Click(object sender, RoutedEventArgs e)
		{
			this.Close();
		}

		private void btnSave_Click(object sender, RoutedEventArgs e)
		{
			try
			{
				Settings.Default.BaudRate = int.Parse(cmbBaudrate.Text);
				Settings.Default.DataBits = int.Parse(cmbDataBits.Text);
				Settings.Default.Parity = (Parity)Enum.Parse(typeof(Parity), cmbParity.Text);
				Settings.Default.StopBits = (StopBits)Enum.Parse(typeof(StopBits), cmbStopBits.Text);
				Settings.Default.PortName = cmbCOMPort.Text;

				Settings.Default.Save();

				MessageBox.Show(this, "Save successfully.\nPlease restart the app to apply the setting.", "Save successfully", MessageBoxButton.OK, MessageBoxImage.Information);
			}
			catch (Exception ex)
			{
				MessageBox.Show(this, "Can't save this.\nPlease try again.", "Can't save", MessageBoxButton.OK, MessageBoxImage.Error);
			}
		}

		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			if (closeNow)
				this.Close();
		}
	}

}
