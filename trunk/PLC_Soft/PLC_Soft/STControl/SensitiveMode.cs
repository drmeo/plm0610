using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class SensitiveMode
    {
        public string DisplayName { get; set; }
        public int Value { get; set; }
    }

    public class SensitiveModes
    {
        private List<SensitiveMode> sms;
        public SensitiveModes()
        {
            sms = new List<SensitiveMode>();
            SensitiveMode sm;
            sm = new SensitiveMode();
            sm.DisplayName = "Normal Sensitivity";
            sm.Value = 0;
            sms.Add(sm);

            sm = new SensitiveMode();
            sm.DisplayName = "High Sensitivity";
            sm.Value = 1;
            sms.Add(sm);
        }
        public List<SensitiveMode> SMs
        {
            get
            {
                return sms;
            }
        }

    }
}
