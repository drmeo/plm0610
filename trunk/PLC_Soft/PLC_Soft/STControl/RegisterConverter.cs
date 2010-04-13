using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;

namespace PLC_Soft
{
    class RegisterConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            string result = "";
            //for first byte
            int[] frequency = (int[])values[0];
            int[] baudrate = (int[])values[1];
            int deviation = (int)values[2];
            int watchdog = (int)values[3];
            //for first and second byte
            int[] txTimeout = (int[])values[4];
            //for second byte
            int[] freqDetTime = (int[])values[5];
            int zeroCrossing = (int)values[6];
            int[] detectMethod = (int[])values[7];
            int mainInterface = (int)values[8];
            int[] outputClock = (int[])values[9];
            int sensitiveMode = (int)values[10];
            int inputFilter = (int)values[11];

            int firstbyte = Pow2(frequency[0], 0) + Pow2(frequency[1], 1) +
                Pow2(frequency[2], 2) + Pow2(baudrate[0], 3) + Pow2(baudrate[1], 4) +
                Pow2(deviation, 5) + Pow2(watchdog, 6) + Pow2(txTimeout[0], 7);

            int secondbyte = Pow2(txTimeout[1], 8 % 8) + Pow2(freqDetTime[0], 9 % 8) +
                Pow2(freqDetTime[1], 10 % 8) + Pow2(zeroCrossing, 11 % 8) + Pow2(detectMethod[0], 12 % 8) +
                Pow2(detectMethod[1], 13 % 8) + Pow2(mainInterface, 14 % 8) + Pow2(outputClock[0], 15 % 8);


            int thirdbyte = Pow2(outputClock[1], 16 % 8) + Pow2(1, 17 % 8) +
                Pow2(1, 20 % 8) + Pow2(sensitiveMode, 22 % 8) + Pow2(inputFilter, 23 % 8);

            result = System.Convert.ToString(thirdbyte, 2).PadLeft(8, '0') + "-" +
                System.Convert.ToString(secondbyte, 2).PadLeft(8, '0') + "-" +
                System.Convert.ToString(firstbyte, 2).PadLeft(8, '0');

            return result;
        }

        private int Pow2(int value, int pow)
        {
            return value * (int)Math.Pow(2, pow);
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();

        }
    }
}
