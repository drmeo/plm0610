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
        public static byte[] ReadData(SerialPort serialPort)
        {

            byte[] buffer = null;
            byte start = (byte)serialPort.ReadByte();
            if (start == (byte)RS232Command.COM_HEADER)
            {
                byte command = (byte)serialPort.ReadByte();
                byte length = (byte)serialPort.ReadByte();
                buffer = new byte[length + 2];
                serialPort.Read(buffer, 2, length);
                buffer[0] = command;
                buffer[1] = length;
            }
            return buffer;
        }

        public static string DataProcess(byte[] data)
        {
            string result = "";
            if (data != null)
            {
                switch (data[0])
                {
                    case ((byte)RS232Command.COM_GET_CTR):
                        for (int i = 2; i < (int)data[1]; i++)
                            result = result + (System.Convert.ToString(i, 2)).PadLeft(8, '0') + "-";
                        //result = result.Remove(result.Length - 1, 1);
                        break;
                    case ((byte)RS232Command.COM_SET_CTR):
                        result = "ST Control register was written successful";
                        break;
                    default:
                        result = result + Encoding.ASCII.GetString(data, 2, data[1]);
                        break;
                }
            }

            return result;
        }

    }
}
