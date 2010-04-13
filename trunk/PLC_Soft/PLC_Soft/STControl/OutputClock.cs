using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class OutputClock
    {
        public string DisplayName { get; set; }
        public int[] Value { get; set; }
    }

    public class OutputClocks
    {
        List<OutputClock> outputclks;
        public OutputClocks()
        {
            outputclks = new List<OutputClock>();
            OutputClock outputclk;
            outputclk = new OutputClock();
            outputclk.DisplayName = "16 Mhz";
            outputclk.Value = new int[] { 0, 0 };
            outputclks.Add(outputclk);
            outputclk = new OutputClock();
            outputclk.DisplayName = "8 MHz";
            outputclk.Value = new int[] { 1, 0 };
            outputclks.Add(outputclk);
            outputclk = new OutputClock();
            outputclk.DisplayName = "4 MHz";
            outputclk.Value = new int[] { 0, 1 };
            outputclks.Add(outputclk);
            outputclk = new OutputClock();
            outputclk.DisplayName = "Not used";
            outputclk.Value = new int[] { 1, 1 };
            outputclks.Add(outputclk);
        }

        public List<OutputClock> OutputCLKs
        {
            get
            {
                return outputclks;
            }
        }
    }
}
