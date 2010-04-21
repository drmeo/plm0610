using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class MainInterface
    {
        public string DisplayName { get; set; }
        public int Value { get; set; }
    }

    public class MainInterfaces
    {
        private List<MainInterface> minterfaces;
        public MainInterfaces()
        {
            minterfaces = new List<MainInterface>();
            MainInterface minterface;
            minterface = new MainInterface();
			minterface.DisplayName = "Synchronous";
            minterface.Value = 0;
            minterfaces.Add(minterface);

            minterface = new MainInterface();
			minterface.DisplayName = "Asynchronous";
            minterface.Value = 1;
            minterfaces.Add(minterface);
        }
        public List<MainInterface> Minterfaces
        {
            get
            {
                return minterfaces;
            }
        }

    }
}
