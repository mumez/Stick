baseline
baseline: spec
	<baseline>

	spec for: #'common' do: [
		spec 
			package: 'Stick-Core'.
		spec 
			group: 'default' with: #('Core');
			group: 'Core' with: #('Stick-Core')].
