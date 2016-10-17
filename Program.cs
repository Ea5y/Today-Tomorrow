using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EventHandleFanTest
{
    //Inherit from EventArgs
    public class MyEventArgs:EventArgs
    {
        private string msg;
        //Constructor
        public MyEventArgs(string messageData)
        {
            msg = messageData;
        }
        //A function
        public string Message
        {
            get {return msg;}
            set {msg = value;}
        }
    }
    public class HasEvent
    {
        //define a EventHandler<> ,params is (object obj, EventArgs args)
        public event EventHandler<MyEventArgs> SampleEvent;
        //a event demo
        public void DemoEvent(string val)
        {
            //
            EventHandler<MyEventArgs> temp = SampleEvent;
            if(temp != null)
                //send event
                temp(this, new MyEventArgs(val));
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            HasEvent he = new HasEvent();
            //regist SampleEventHandler to he.SampleEvent
            he.SampleEvent += new EventHandler<MyEventArgs>(SampleEventHandler);
            he.DemoEvent("Hey there,Bruce!");
            he.DemoEvent("How are you today?");
            he.DemoEvent("I'm pretty good.");
            he.DemoEvent("Thanks for asking~");
        }

        //accept the event from HasEvent,the params is same with EventHandler<>
        private static void SampleEventHandler(object src, MyEventArgs mea)//
        {
            Console.WriteLine(mea.Message);
        }
    }
}
