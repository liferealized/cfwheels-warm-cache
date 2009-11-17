<cfcomponent output="false">

	<cffunction name="init" output="false" access="public">
		<cfset this.version = "1.0" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="warmCache" access="public" output="false" returntype="void" mixin="application">
		<cfargument name="warmControllerCache" type="boolean" required="false" default="true" />
		<cfargument name="warmModelCache" type="boolean" required="false" default="true" />
		<cfscript>
			var loc = {
				  controllerPath =  application.wheels.rootPath & application.wheels.controllerComponentPath
				, modelPath =  application.wheels.rootPath & application.wheels.modelComponentPath
			};
			
			if (not ListFindNoCase("testing,production,maintenance", application.wheels.environment))
				return;
		
			if (arguments.warmControllerCache) {
			
				loc.controllers = $directory(action="list", directory=ExpandPath(loc.controllerPath), filter="*.cfc", listinfo="name", recurse=false, type="file");
				loc.iEnd = loc.controllers.RecordCount;
				
				for (loc.i=1; loc.i lte loc.iEnd; loc.i++) {
					loc.controllerName = Replace(loc.controllers.name[loc.i], ".cfc", "", "all");
					// get each controller we find into the cache
					loc.controller = $controller(loc.controllerName);
				}
			}
			
			if (arguments.warmModelCache) {
			
				loc.models = $directory(action="list", directory=ExpandPath(loc.modelPath), filter="*.cfc", listinfo="name", recurse=false, type="file");
				loc.iEnd = loc.controllers.RecordCount;
				
				for (loc.i=1; loc.i lte loc.iEnd; loc.i++) {
					loc.modelName = Replace(loc.models.name[loc.i], ".cfc", "", "all");
					
					// get each model we find into the cache
					try {
						loc.model = model(loc.modelName);
					} catch (Any e) {
						// do nothing
					}
				}
			}
		</cfscript>
		<cfreturn />
	</cffunction>

</cfcomponent>