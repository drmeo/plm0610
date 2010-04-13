using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class DetectionMethod
    {
        public string DisplayName { get; set; }
        public int[] Value { get; set; }
    }

    public class DetectionMethods
    {
        List<DetectionMethod> dms;
        public DetectionMethods()
        {
            dms = new List<DetectionMethod>();
            DetectionMethod dm;
            dm = new DetectionMethod();
            dm.DisplayName = "Carrier det no con";
            dm.Value = new int[] { 0, 0 };
            dms.Add(dm);
            dm = new DetectionMethod();
            dm.DisplayName = "Carrier det with con";
            dm.Value = new int[] { 1, 0 };
            dms.Add(dm);
            dm = new DetectionMethod();
            dm.DisplayName = "Preamble det no con";
            dm.Value = new int[] { 0, 1 };
            dms.Add(dm);
            dm = new DetectionMethod();
            dm.DisplayName = "Preamble det with con";
            dm.Value = new int[] { 1, 1 };
            dms.Add(dm);
        }

        public List<DetectionMethod> DMs
        {
            get
            {
                return dms;
            }
        }
    }
}
