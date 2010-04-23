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
using PLC_Soft.Properties;

namespace PLC_Soft
{
	/// <summary>
	/// Interaction logic for frmIPConfig.xaml
	/// </summary>
	public partial class frmIPConfig : Window
	{
		public frmIPConfig()
		{
			InitializeComponent();
		}

		private void btnSave_Click(object sender, RoutedEventArgs e)
		{
			try
			{
				Settings.Default.IPAddress = txtIPAdd.Text;
				Settings.Default.DomainAddress = txtDomainAdd.Text;
				Settings.Default.MasterAddress = txtMasterAdd.Text;
				Settings.Default.Save();
				MessageBox.Show(this, "Save successfully.\nPlease restart the app to apply the setting.", "Save successfully", MessageBoxButton.OK, MessageBoxImage.Information);
			}
			catch (Exception ex)
			{
				MessageBox.Show(this, "Can't save this.\nPlease try again.", "Can't save", MessageBoxButton.OK, MessageBoxImage.Error);
			}
		}

		private void InitializeControlValues()
		{

		}

		private void btnCancel_Click(object sender, RoutedEventArgs e)
		{
			this.Close();
		}
	}
}
