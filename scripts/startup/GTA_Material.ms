plugin Material GTA_Mtl
    name:"GTA Material"
    classID:#(0x48238272, 0x48206285)
	extends:Standard replaceUI:true 
(
	parameters main rollout:params 
	(
		amb					type:#float default:1.0 	ui:amb
		spc					type:#float default:1.0 	ui:spc
		dif					type:#float default:1.0 	ui:dif
		color 				type:#color default:gray 	ui:pccol 
		colormap 			type:#TextureMap  			ui:pccolmap
		use_colormap 		type:#boolean default:true	ui:pcuse
		alpha				type:#integer default:255	ui:popy
		alphamap 			type:#TextureMap  			ui:popymap
		use_alphamap 		type:#boolean default:true ui:pouse
		Reflection			type:#float default:100		ui:pref
		reflectionmap 		type:#TextureMap  			ui:prefmap
		use_reflectionmap 	type:#boolean default:true	ui:pruse
		specular			type:#color default:black 	ui:pscol 
		specularmap 		type:#TextureMap  			ui:pspcmap
		use_specularmap 	type:#boolean default:true	ui:psuse		
		spec_alpha			type:#integer default:255	ui:pspca
		spec_power			type:#float default:100		ui:pspwr
		blend 				type:#float default:1.0 	ui:srblend
		colhprIdx	type:#integer 	default:1	ui:colhpr
		on color set val do delegate.diffuse_color = val 
		on colormap set tex do ( delegate.diffuseMap = tex; delegate.diffuseMapAmount = 90; delegate.diffuseMapEnable = use_colormap )
		on use_colormap set state do delegate.diffuseMapEnable = state
		on spec_power set val do delegate.specular_level = val
		on specular set val do delegate.specular_color = val
		on specularmap set tex do ( delegate.specularMap = tex; delegate.specularMapEnable = use_specularmap  )
		on use_specularmap set state do delegate.specularMapEnable = state
 		on alpha set val do delegate.opacity = val/255.0*100
		on alphamap set tex do ( delegate.opacityMap = tex; delegate.opacityMapEnable = use_alphamap )
		on use_alphamap set state do delegate.opacityMapEnable = state
		on Reflection set val do delegate.reflectionMapAmount = val
		on reflectionmap set tex do ( delegate.reflectionMap = tex; delegate.reflectionMapEnable = use_reflectionmap )
		on use_reflectionmap set state do delegate.reflectionMapEnable = state
	)
	rollout params  "GTA Parameters"
	(
 		label info01 "This Shader only works for GTA Exporter."

		label lblc "Color Guide" pos:[130,38]
		dropdownlist colhpr "" width:120 items:#("None","Primary","Sccondary","Left Headlight","Right Headlight","Left Taillight","Right Taillight") pos:[195,35]

		group "Main"(
      	  label dmy	 ""
			spinner 		amb			"Ambient"	fieldwidth:45 range:[0,1,0]	pos:[10,80] 
			spinner 		spc			"Specular"	fieldwidth:45 range:[0,1,0]	pos:[115,80]
			spinner 		dif			"Diffuse"	fieldwidth:45 range:[0,1,0]	pos:[225,80]
			label			pclbl		"Color " 	pos:[10,105]
 			colorpicker		pccol 		"" 			pos:[65,103] 
			checkbox 		pcuse		""			pos:[130,105]
        	mapbutton		pccolmap	"None" 		width:165 pos:[150,103]			
			label			polbl		"Alpha " 	pos:[10,130]
			spinner			popy		""	fieldwidth:45 type:#integer range:[0,255,255] pos:[65,130]	
			checkbox 		pouse		""			pos:[130,130]
			mapbutton		popymap		"None" 		width:165 pos:[150,128]
		)
		group "Reflection Image" (
			label			prlbl		"Reflection" pos:[10,180]
			spinner			pref		""	fieldwidth:45 range:[0,100,0] pos:[65,180]	
			checkbox 		pruse		""			pos:[130,180]
	        mapbutton		prefmap		"None" 		width:165 pos:[150,178]
		)
		group "Specular Image" (
			label			psplbl		"Spec Size" 	pos:[10,230]
			spinner 		pspwr 		"" fieldwidth:45 range:[0,100,100] pos:[65,230]
			checkbox 		psuse		""			pos:[130,230]
	        mapbutton		pspcmap		"None" 		width:165 pos:[150,228]
		)
		group "SA Specular" (
			label			pslbl		"Specular" 	pos:[10,280] 
	 		colorpicker		pscol 		"" 			pos:[65,278]
			label			psalbl		"Spec Alpha" 	pos:[135,280] 
			spinner 		pspca 		""			fieldwidth:45 type:#integer range:[0,255,255] pos:[200,280]
			label			psrlbl		"Spec/Ref Blend" 	pos:[120,300] 
			spinner 		srblend		""		fieldwidth:45 range:[0,100,100] pos:[200,300]
		)	
		button veldft "SA Vehicle default" width:120 tooltip:"Setup default Reflection/Specular" across:2
		button othdft "Other default" width:120 tooltip:"For use with weapon, building etc."
		
		label info12 "" 
        label info13 "By Kam © Jul 2005" align:#right
		label info14 "" 
		label info15 "** Thanks ashdexx for the detail explanation **" 
		
		on veldft pressed do (
			this.reflectionmap= Bitmaptexture fileName:"xvehicleenv128.tga"
			this.specularmap = Bitmaptexture fileName:"vehiclespecdot64.tga"
			this.specular.r=255;this.specular.g=255;this.specular.b=255
			pspcmap.text = "vehiclespecdot64.tga"
			prefmap.text = "xvehicleenv128.tga"
			this.blend=0.05
		)
		on othdft pressed do (
			this.reflectionmap= undefined
			this.specularmap = undefined
			this.color.r=255;this.color.g=255;this.color.b=255
			this.specular.r=0;this.specular.g=0;this.specular.b=0
			this.alpha = 255
		)
		
		on colhpr selected val do (
			case val of (
				7: (this.color.r=255;this.color.g=60;this.color.b=0)
				6: (this.color.r=185;this.color.g=255;this.color.b=0)
				5: (this.color.r=0;this.color.g=255;this.color.b=200)
				4: (this.color.r=255;this.color.g=175;this.color.b=0)
				3: (this.color.r=255;this.color.g=0;this.color.b=175)
				2: (this.color.r=60;this.color.g=255;this.color.b=0)
			)
			colhprIdx = val			
		)
 	)
	on create do (
		this.name = delegate.name
	)
	on load do (
		this.name = delegate.name
--		use_colormap = delegate.diffuseMapEnable
--		use_specularmap = delegate.specularMapEnable
--		use_alphamap = delegate.opacityMapEnable
--		use_reflectionmap = delegate.reflectionMapEnable
	)
	
)
