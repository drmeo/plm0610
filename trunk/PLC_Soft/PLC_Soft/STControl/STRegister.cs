using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    class STRegister
    {
        private List<int> register;
        public STRegister()
        {
            register = new List<int>(48);
            for (int i = 0; i < register.Capacity; i++)
            {
                register[i] = 1;
            }
        }

        public List<int> Register
        {
            get
            {
                return register;
            }
            set
            {
                register = value;
            }
        }
    }
}
