class PlankEvent { }

class PlankCounterEvent extends PlankEvent {
  int millis;
  PlankCounterEvent(this.millis);
}

class PlankStopEvent extends PlankEvent { }

class PlankResetEvent extends PlankEvent { }