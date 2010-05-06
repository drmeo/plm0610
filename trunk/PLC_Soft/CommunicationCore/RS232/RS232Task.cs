using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Ports;
using System.Threading;

namespace CommunicationCore.RS232
{
	public class RS232Task
	{
		/// <summary>
		/// Read data from rs232
		/// </summary>
		/// <param name="serialPort">SerialPort object</param>
		/// <returns>data from rs232</returns>
		public static byte[] ReadData(SerialPort serialPort)
		{
			byte[] buffer = null;
			byte start = (byte)serialPort.ReadByte();
			if (start == (byte)RS232Command.COM_HEADER)
			{
				Thread.Sleep(20);
				byte command = (byte)serialPort.ReadByte();
				byte length = (byte)serialPort.ReadByte();
				buffer = new byte[length + 2];
				Thread.Sleep(2 * length);
				serialPort.Read(buffer, 2, length);
				buffer[0] = command;
				buffer[1] = length;
			}
			return buffer;
		}

		/// <summary>
		/// Add header before send to rs2323
		/// </summary>
		/// <param name="data"></param>
		/// <param name="header"></param>
		/// <param name="code"></param>
		/// <returns></returns>
		public static byte[] AddHeaderInformation(byte[] data, byte header, byte code)
		{
			byte[] processedData = new byte[data.Length + 3];
			for (int i = 0; i < data.Length; i++)
			{
				processedData[i + 3] = data[i];
			}
			processedData[0] = header;
			processedData[1] = code;
			processedData[2] = (byte)data.Length;
			return processedData;
		}


		public static string GetPLMRegister(byte[] data)
		{
			string result = "";
			if (data != null)
			{

				for (int i = 2; i < (int)(data[1] + 1); i++)
					result = result + (System.Convert.ToString(data[i], 2)).PadLeft(8, '0') + "-";
				result = result.Remove(result.Length - 1, 1);
			}

			return result;
		}

		public static string GetDataFromPLM(byte[] data)
		{
			string result = "";
			if (data != null)
			{
				result = result + Encoding.ASCII.GetString(data, 9, data[1] - 7);
			}
			return result;
		}

		/// <summary>
		/// get the command of frame
		/// </summary>
		/// <param name="data"></param>
		/// <returns></returns>
		public static byte GetCommand(byte[] data)
		{
			return data[0];
		}

	}
}
