// https://wiki.gnome.org/Projects/Vala/GeeSamples

//  new Range (10, 20).each ((i) => {
//      stdout.printf ("%d\n", i);
//  });

using Gee;

//  class RangeIterator : Object, Iterator<int>, Traversable<int> {

//      private Range range;
//      private int current;

//      public RangeIterator (Range range) {
//          this.range = range;
//          this.current = range.from - 1;
//      }

//      public bool next () {
//          if (!has_next ()) {
//              return false;
//          }
//          this.current++;
//          return true;
//      }

//      public bool has_next () {
//          return this.current < this.range.to;
//      }

//      public bool first () {
//          this.current = range.from;
//          return true;
//      }

//      /* Here the 'new' keyword is used because Object already
//         has a 'get' method. This will hide the original method.
//         Otherwise you'll get a warning. */
//      public new int get () {
//          return this.current;
//      }

//      public void remove () {
//          assert_not_reached ();
//      }

//      public override bool read_only {
//  		get { return false; }
//  	}

//      public bool valid {
//          get {
//              return true;
//          }
//      }

//      public bool foreach(ForallFunc<int> f) {
//          // FIXME TODO
//  		//  for (int i = 0; i < _size; i++) {
//  		//  	if (!f (_items[i])) {
//  		//  		return false;
//  		//  	}
//  		//  }
//  		return true;
//  	}

//  }

//  public class Range : Object, Iterable<int>, Traversable<int> {

//      public int from { get; private set; }
//      public int to { get; private set; }

//      public Range (int from, int to) {
//          // assert (from < to);
//          this.from = from;
//          this.to = to;
//      }

//      public Type element_type {
//          get { return typeof (int); }
//      }

//      public Iterator<int> iterator () {
//          return new RangeIterator (this);
//      }

//      public delegate void RangeEachFunc (int i);

//      public void each (RangeEachFunc each_func) {
//          foreach (int i in this) {
//              each_func (i);
//          }
//      }

//      public bool foreach (ForallFunc<int> f) {
//          foreach (int i in this) {
//              f (i);
//          }
//          return true;
//      }
//  }
