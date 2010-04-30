using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CommunicationCore.PLM
{
	public class IPInformation
	{
		public byte FriendID { get; set; }
		public byte DomainID { get; set; }
		public DateTime LastBroadCast { get; set; }
	}
}
