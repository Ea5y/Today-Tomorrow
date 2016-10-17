using UnityEngine;
using System.Collections;
using System.Collections.Generic;

#region FiberSet
public class FiberSet
{
	private List<Fiber> fiberlist;

	public int Count { get { return fiberlist.Count; } }

	public FiberSet()
	{
		fiberlist = new List<Fiber>();
	}

	public bool Update()
	{
		foreach(Fiber fiber in fiberlist.ToArray())
		{
			fiber.Update();
			if(!fiber.IsWait)
			{
				fiberlist.Remove(fiber);
			}
		}

		return (fiberlist.Count != 0);
	}
	public Fiber AddFiber(IEnumerator fiber)
	{
		Fiber ret = new Fiber(fiber);
		fiberlist.Add(ret);
		return ret;
	}
	public Fiber AddFiber(Fiber fiber)
	{
		fiberlist.Add(fiber);
		return fiber;
	}
	public bool Remove(Fiber fiber)
	{
		return fiberlist.Remove(fiber);
	}
	public void Clear()
	{
		fiberlist.Clear();
	}
	public bool Contains(Fiber fiber)
	{
		return fiberlist.Contains(fiber);
	}
}
#endregion

#region Fiber
public class Fiber : IFiberWait
{
	private readonly IEnumerator fiber;

	public bool IsFinished{ get { return !(this.IsWait); } }
	public bool IsError{ get; private set; }
	public bool IsWait{ get; private set; }

	public Fiber(IEnumerator fiber)
	{
		this.fiber = fiber;
		this.IsWait = true;
		this.IsError = false;
	}

	public bool Update()
	{
		IFiberWait wait = this.fiber.Current as IFiberWait;
		if(wait != null && wait.IsWait)
		{
			this.IsWait  = true;
		}
		else
		{
			try
			{
				this.IsWait  = this.fiber.MoveNext();
			}
			catch(System.Exception e)
			{
				BugReportController.SaveLogFile(e.ToString());
				IsError = true;
				this.IsWait  = false;
			}
		}
		
		return this.IsWait ;
	}
}
#endregion

#region IFiberWait
public interface IFiberWait
{
	bool IsWait { get; }
}

public class WaitSeconds : IFiberWait
{
	float endTime;
	public WaitSeconds(float waitTime)
	{
		this.endTime = waitTime + Time.time;
	}
	public bool IsWait
	{
		get
		{
			return (Time.time < this.endTime);
		}
	}
}
#endregion
