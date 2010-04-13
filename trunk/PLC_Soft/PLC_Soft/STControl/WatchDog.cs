using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class WatchDog
    {
        public string DisplayName { get; set; }
        public int Value { get; set; }
    }

    public class WatchDogs
    {
        private List<WatchDog> watchdogs;
        public WatchDogs()
        {
            watchdogs = new List<WatchDog>();
            WatchDog watchdog;
            watchdog = new WatchDog();
            watchdog.DisplayName = "Disable";
            watchdog.Value = 0;
            watchdogs.Add(watchdog);

            watchdog = new WatchDog();
            watchdog.DisplayName = "Enable (1.5 s)";
            watchdog.Value = 1;
            watchdogs.Add(watchdog);
        }
        public List<WatchDog> WDs
        {
            get
            {
                return watchdogs;
            }
        }

    }
}
