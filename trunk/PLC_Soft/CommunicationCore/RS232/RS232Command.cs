using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CommunicationCore.RS232
{
    public enum RS232Command
    {
        COM_GET_CTR = 0,
        COM_SET_CTR = 1,
        COM_GET_PLM = 2,
        COM_SET_PLM = 3,
		COM_GET_MAXLENGTH = 4,
		COM_SET_MAXLENGTH = 5,
		COM_BROADCAST = 255,
        COM_HEADER = 170,
    }
}
