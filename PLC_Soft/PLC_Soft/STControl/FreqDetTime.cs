using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class FreqDetTime
    {
        public string DisplayName { get; set; }
        public int[] Value { get; set; }
    }

    public class FreqDetTimes
    {
        List<FreqDetTime> fdts;
        public FreqDetTimes()
        {
            fdts = new List<FreqDetTime>();
            FreqDetTime fdt;
            fdt = new FreqDetTime();
            fdt.DisplayName = "0.5 ms";
            fdt.Value = new int[] { 0, 0 };
            fdts.Add(fdt);
            fdt = new FreqDetTime();
            fdt.DisplayName = "1 ms";
            fdt.Value = new int[] { 1, 0 };
            fdts.Add(fdt);
            fdt = new FreqDetTime();
            fdt.DisplayName = "3 ms";
            fdt.Value = new int[] { 0, 1 };
            fdts.Add(fdt);
            fdt = new FreqDetTime();
            fdt.DisplayName = "5 ms";
            fdt.Value = new int[] { 1, 1 };
            fdts.Add(fdt);
        }

        public List<FreqDetTime> FDTS
        {
            get
            {
                return fdts;
            }
        }
    }
}
