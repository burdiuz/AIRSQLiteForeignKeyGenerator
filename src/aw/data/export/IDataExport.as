package aw.data.export{
	import mx.collections.IList;

	public interface IDataExport{
		function create(list:IList):String;
	}
}