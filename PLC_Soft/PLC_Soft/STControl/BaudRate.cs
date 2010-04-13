using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class BaudRate
    {
        public string DisplayName { get; set; }
        public int[] Value { get; set; }
    }

    public class BaudRates
    {
        List<BaudRate> bauds;
        public BaudRates()
        {
            bauds = new List<BaudRate>();
            BaudRate baud;
            baud = new BaudRate();
            baud.DisplayName = "600";
            baud.Value = new int[] { 0, 0 };
            bauds.Add(baud);
            baud = new BaudRate();
            baud.DisplayName = "1200";
            baud.Value = new int[] { 1, 0 };
            bauds.Add(baud);
            baud = new BaudRate();
            baud.DisplayName = "2400";
            baud.Value = new int[] { 0, 1 };
            bauds.Add(baud);
            baud = new BaudRate();
            baud.DisplayName = "4800";
            baud.Value = new int[] { 1, 1 };
            bauds.Add(baud);
        }

        public List<BaudRate> Bauds
        {
            get
            {
                return bauds;
            }
        }
    }
}
