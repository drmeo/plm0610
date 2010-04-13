using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class InputFilter
    {
        public string DisplayName { get; set; }
        public int Value { get; set; }
    }

    public class InputFilters
    {
        private List<InputFilter> inputfilters;
        public InputFilters()
        {
            inputfilters = new List<InputFilter>();
            InputFilter inputfilter;
            inputfilter = new InputFilter();
            inputfilter.DisplayName = "Disable";
            inputfilter.Value = 0;
            inputfilters.Add(inputfilter);

            inputfilter = new InputFilter();
            inputfilter.DisplayName = "Enable";
            inputfilter.Value = 1;
            inputfilters.Add(inputfilter);
        }
        public List<InputFilter> Inputfilters
        {
            get
            {
                return inputfilters;
            }
        }

    }
}
