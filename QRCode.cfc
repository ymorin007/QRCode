<!--- 
Overview - https://google-developers.appspot.com/chart/infographics/docs/overview

https://chart.googleapis.com/chart? - All infographic URLs start with this root URL, followed by one or more parameter/value pairs. The required and optional parameters are specific to each image; read your image documentation.
chs - Size of the image in pixels, in the format <width>x<height>
cht - Type of image: 'qr' means QR code.
chl - The data to encode. Must be URL-encoded.

 --->

<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.1.6">
		<cfreturn this>
	</cffunction>

	<cffunction name="QRCodeImage" returntype="string" access="public" output="true">

		<cfargument name="linkTo" required="true" hint="URL to link to. ex.: https://bizonbytes.com">
		<cfargument name="width" required="false" default="150" hint="Width of QR Code image">		
		<cfargument name="destination" required="false" default="/#application.wheels.imagePath#" hint="Where to save your image?">		
		<cfargument name="filename" required="false" default="qr" hint="Filename without the extension">
		<cfargument name="showImage" required="false" default="true" type="boolean" hint="Do you want to show the image? No will only save the QR image file">		
		<cfargument name="abortIfExist" required="false" default="false" hint="Won't create the QR Code from google if the file already exist in your destination folder">

			<cfif structKeyExists(arguments, "linkTo")>

				<cfset file = "#fullPathDirectory()#/#arguments.destination#/#arguments.filename#.png">

				<cfif (arguments.abortIfExist EQ "false") OR
						(arguments.abortIfExist EQ "true" AND NOT FileExists(file))>					
				
					<!--- We will be calling google chart API to return the QR Code
							We are using urlencodedformat() since the data must be URL-encoded.
					 --->
					<cfhttp url="http://chart.apis.google.com/chart?chs=#arguments.width#x#arguments.width#&cht=qr&chl=#urlencodedformat(arguments.linkTo)#" 
							result="qrCode" 
							method="get" 
							getAsBinary="yes">

					<!--- If google return a qrCode then lets write the image to the destination folder --->
					<cfif structKeyExists(qrCode, "filecontent") AND DirectoryExists(thisDirectory)>

						<cfimage action="write" 
								destination="#fullPathDirectory()#/#arguments.destination#/#arguments.filename#.png"
								source="#qrCode.filecontent#"
								overwrite="true"/>

					</cfif>							
				</cfif>

				<cfif arguments.showImage EQ "true">		
					<img src="#arguments.destination#/#arguments.filename#.png" width="#arguments.width#" height="#arguments.width#">
				</cfif>
	
			</cfif>

	</cffunction>
	
	<cffunction name="fullPathDirectory" hint="Return the full path of the directory">
	
		<cfargument name="directory" hint="Directory name" default="" required="false">
	
		<cfset thisPath = ExpandPath("*.*")>
	
		<cfset thisDirectory = GetDirectoryFromPath(thisPath) & "#arguments.directory#">
	
		<cfreturn thisDirectory>
	
	</cffunction>	

</cfcomponent>