using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class Frequency
    {
        public string DisplayName { get; set; }
        public int[] Value { get; set; }
    }
    public class Frequencies
    {
        List<Frequency> freqs;
        public Frequencies()
        {
            freqs = new List<Frequency>();
            Frequency freq;
            freq = new Frequency();
            freq.DisplayName = "60 KHz";
            freq.Value = new int[] { 0, 0, 0 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "66 KHz";
            freq.Value = new int[] { 1, 0, 0 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "72 KHz";
            freq.Value = new int[] { 0, 1, 0 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "76 KHz";
            freq.Value = new int[] { 1, 1, 0 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "82.05 KHz";
            freq.Value = new int[] { 0, 0, 1 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "86 KHz";
            freq.Value = new int[] { 1, 0, 1 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "110 KHz";
            freq.Value = new int[] { 0, 1, 1 };
            freqs.Add(freq);
            freq = new Frequency();
            freq.DisplayName = "132.5 KHz";
            freq.Value = new int[] { 1, 1, 1 };
            freqs.Add(freq);
        }
        public List<Frequency> Freqs {
            get
            {
                return freqs;
            }
        }
    }
}
