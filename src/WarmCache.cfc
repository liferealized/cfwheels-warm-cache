<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "1.0" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="warmCache" access="public" output="false" returntype="void" mixin="application">
		<cfargument name="warmControllerCache" type="boolean" required="false" default="true" />
		<cfargument name="warmModelCache" type="boolean" required="false" default="true" />
		<cfscript>
var local = {
	  controllerPath =  application.wheels.rootPath & application.wheels.controllerComponentPath
	, modelPath =  application.wheels.rootPath & application.wheels.modelComponentPath
};
			
			if (not ListFindNoCase("testing,production,maintenance", application.wheels.environment))
				return;
		
			if (arguments.warmControllerCache) {
			
				local.controllers = $directory(action="list", directory=ExpandPath(local.controllerPath), filter="*.cfc", listinfo="name", recurse=false, type="file");
				local.iEnd = local.controllers.RecordCount;
				
				for (local.i=1; local.i lte local.iEnd; local.i++) {
					local.controllerName = Replace(local.controllers.name[local.i], ".cfc", "", "all");
					// get each controller we find into the cache
					local.controller = $controller(local.controllerName);
				}
			}
			
			if (arguments.warmModelCache) {
			
				local.models = $directory(action="list", directory=ExpandPath(local.modelPath), filter="*.cfc", listinfo="name", recurse=false, type="file");
				local.iEnd = local.controllers.RecordCount;
				
				for (local.i=1; local.i lte local.iEnd; local.i++) {
					local.modelName = Replace(local.models.name[local.i], ".cfc", "", "all");
					// get each model we find into the cache
					
					try {
						local.model = model(local.modelName);
					} catch (Any e) {
						// do nothing
					}
				}
			}
		</cfscript>
		<cfreturn />
	</cffunction>

</cfcomponent>