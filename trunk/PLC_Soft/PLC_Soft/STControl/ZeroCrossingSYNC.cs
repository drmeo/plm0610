using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class ZeroCrossingSYNC
    {
        public string DisplayName { get; set; }
        public int Value { get; set; }
    }

    public class ZeroCrossingSYNCs
    {
        private List<ZeroCrossingSYNC> zcrs;
        public ZeroCrossingSYNCs()
        {
            zcrs = new List<ZeroCrossingSYNC>();
            ZeroCrossingSYNC zcr;
            zcr = new ZeroCrossingSYNC();
            zcr.DisplayName = "Disable";
            zcr.Value = 0;
            zcrs.Add(zcr);

            zcr = new ZeroCrossingSYNC();
            zcr.DisplayName = "Enable";
            zcr.Value = 1;
            zcrs.Add(zcr);
        }
        public List<ZeroCrossingSYNC> ZCRS
        {
            get
            {
                return zcrs;
            }
        }

    }
}
