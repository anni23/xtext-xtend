package org.eclipse.xtend.ide.codebuilder

import com.google.inject.Inject
import org.eclipse.xtend.core.jvmmodel.IXtendJvmAssociations
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmGenericType
import com.google.inject.Provider
import org.eclipse.xtext.common.types.util.jdt.IJavaElementFinder
import org.eclipse.jdt.core.IType
import org.eclipse.xtend.core.xtend.XtendClass

class CodeBuilderFactory {
	
	@Inject extension IXtendJvmAssociations
	@Inject extension IJavaElementFinder
	
	@Inject Provider<XtendFieldBuilder> xtendFieldBuilderProvider
	@Inject Provider<XtendMethodBuilder> xtendMethodBuilderProvider
	@Inject Provider<XtendConstructorBuilder> xtendConstructorBuilderProvider
	
	@Inject Provider<JavaFieldBuilder> javaFieldBuilderProvider
	@Inject Provider<JavaMethodBuilder> javaMethodBuilderProvider
	@Inject Provider<JavaConstructorBuilder> javaConstructorBuilderProvider
	
	def createFieldBuilder(JvmDeclaredType owner) {
		val ownerSource = owner.source
		val builder = 
			if(ownerSource instanceof XtendClass) 
				xtendFieldBuilderProvider.get
			else
				javaFieldBuilderProvider.get
		builder.owner = owner
		builder.ownerSource = ownerSource
		builder
	}
	
	def createConstructorBuilder(JvmDeclaredType owner) {
		val ownerSource = owner.source
		val builder = 
			if(ownerSource instanceof XtendClass) 
				xtendConstructorBuilderProvider.get
			else
				javaConstructorBuilderProvider.get
		builder.owner = owner
		builder.ownerSource = ownerSource
		builder
	}
	
	def createMethodBuilder(JvmDeclaredType owner) {
		val ownerSource = owner.source
		val builder = 
			if(ownerSource instanceof XtendClass) 
				xtendMethodBuilderProvider.get
			else
				javaMethodBuilderProvider.get
		builder.owner = owner
		builder.ownerSource = ownerSource
		builder
	}
	
	def Object getSource(JvmDeclaredType element) {
		if(element instanceof JvmGenericType) {
			val xtendClass = (element as JvmGenericType).xtendClass
			if(xtendClass != null)
				return xtendClass
		}  
		val jvmElement = findExactElementFor(element)
		if(jvmElement instanceof IType)
			jvmElement
		else 
			null
	}
	
	
}

