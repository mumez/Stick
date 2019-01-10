releasing
releaseAll
	<script>
	self allSubInstances do: [ :e | e release ]