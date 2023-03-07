package memo

import (
	"sync"
)

type Func func(key string) (interface{}, error)

type result struct {
	value interface{}
	err   error
}

type entry struct {
	res   result
	ready chan struct{} // closed when res is ready
}

type Memo struct {
	f Func

	mu    sync.Mutex // guards cache
	cache map[string]*entry
}

func New(f Func) *Memo {
	return &Memo{f: f, cache: make(map[string]*entry)}
}

func (m *Memo) Get1(key string) (value interface{}, err error) {
	m.mu.Lock()
	e := m.cache[key]

	if e == nil {
		// This is the first request for this key.
		// This goroutine becomes responsible for computing
		// the value and broadcasting the rady condition.
		e = &entry{ready: make(chan struct{})}
		m.cache[key] = e
		m.mu.Unlock()

		e.res.value, e.res.err = m.f(key)

		close(e.ready)
	} else {
		// This is a repeat request for this key
		m.mu.Unlock()
		<-e.ready // wait for ready condition
	}

	return e.res.value, e.res.err
}
