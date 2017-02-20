job('Job01') {
    steps {
        shell('''
        	echo "hello world"
    	'''.stripIndent())
    }
}
