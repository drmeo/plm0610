using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class Deviation
    {
        public string DisplayName { get; set; }
        public int Value { get; set; }
    }

    public class Deviations
    {
        private List<Deviation> devs;
        public Deviations()
        {
            devs = new List<Deviation>();
            Deviation dev;
            dev = new Deviation();
            dev.DisplayName = "0.5";
            dev.Value = 0;
            devs.Add(dev);

            dev = new Deviation();
            dev.DisplayName = "1";
            dev.Value = 1;
            devs.Add(dev);
        }
        public List<Deviation> Devs
        {
            get
            {
                return devs;
            }
        }

    }
}
