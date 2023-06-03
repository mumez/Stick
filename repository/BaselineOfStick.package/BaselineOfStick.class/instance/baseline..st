baseline
baseline: spec
	<baseline>

	spec for: #'common' do: [
		spec 
			package: 'Stick-Core'.
		spec 
			group: 'default' with: #('Core');
			group: 'Core' with: #('Stick-Core')].
	spec for: #pharo do:[
		spec package: 'Stick-Core-Pharo'.
		spec package: 'Stick-Core' with: [spec includes: 'Stick-Core-Pharo'].
	].
	spec for: #gemstone do:[
		spec package: 'Stick-Core-GemStone'.
		spec package: 'Stick-Core' with: [spec includes: 'Stick-Core-GemStone'].
	].
