using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLC_Soft
{
    public class TXTimeOut
    {
        public string DisplayName { get; set; }
        public int[] Value { get; set; }
    }

    public class TXTimeOuts
    {
        List<TXTimeOut> txs;
        public TXTimeOuts()
        {
            txs = new List<TXTimeOut>();
            TXTimeOut tx;
            tx = new TXTimeOut();
            tx.DisplayName = "Disable";
            tx.Value = new int[] { 0, 0 };
            txs.Add(tx);
            tx = new TXTimeOut();
            tx.DisplayName = "1 s";
            tx.Value = new int[] { 1, 0 };
            txs.Add(tx);
            tx = new TXTimeOut();
            tx.DisplayName = "3 s";
            tx.Value = new int[] { 0, 1 };
            txs.Add(tx);
            tx = new TXTimeOut();
            tx.DisplayName = "Not used";
            tx.Value = new int[] { 1, 1 };
            txs.Add(tx);
        }

        public List<TXTimeOut> TXs
        {
            get
            {
                return txs;
            }
        }
    }
}
