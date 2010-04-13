using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Input;
using System.Windows;

namespace EventBinding
{
    public class ViewModel
    {
        public ICommand TextChanged
        {
            get
            {
                //  this is very lazy: I should cache the command!  
                return new TextChangedCommand();
            }
        }

        private class TextChangedCommand : ICommand
        {
            public event EventHandler CanExecuteChanged;
            public void Execute(object parameter)
            {
                MessageBox.Show("Text Changed");
            }

            public bool CanExecute(object parameter)
            {
                return true;
            }
        }
    }  
}
