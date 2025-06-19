<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃"%>

<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout"%>

<%@ attribute name="pageName" required="true"%>
<%@ attribute name="bodyContent" fragment="true"%>
<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<html>
<head>
<meta charset="UTF-8">
<title>${pageName}</title>
<link rel="stylesheet" href="${cpath}/resources/css/styles.css">
<script src="https://cdn.tailwindcss.com"></script>
<script type="text/javascript">
	tailwind.config = {
		theme : {
			extend : {
				colors : {
					'gray-1' : '#D8D8D8',
					'gray-2' : '#E7E5E4',
					'gray-3' : '#828688',
					'gray-4' : '#F7F7F7',
					'gray-5' : '#D4D4D4',
					'gray-6' : '#757575',
					'blue-1' : '#4A90E2',
					'blue-2' : '#3F7AB6',
				},
				fontSize : {
					'ts-28' : [
						'1.75rem',
						{
							ineHeight: '100%',
		  					fontWeight: '800'
						}
					],
					'ts-24' : [
						'1.5rem',
						{
							ineHeight: '100%',
		  					fontWeight: '800'
						}
					],
					'ts-20' : [
						'1.25rem',
						{
							ineHeight: '100%',
		  					fontWeight: '800'
						}
					],
					'ts-18' : [
						'1rem',
						{
							ineHeight: '100%',
		  					fontWeight: '800'
						}
					]
				},
				screens : {
					'max-1350': { 'max': '1350px' },
					'max-1300': { 'max': '1300px' },
					'max-1250': { 'max': '1250px' },
					'max-1200': { 'max': '1200px' },
				}
			}
		}
	}
</script>
</head>
<body>
	<layout:header pageType="${pageType}" />
	
	<main class="main-container">
		<jsp:invoke fragment="bodyContent" />
	</main>
	
	<layout:footer pageType="${pageType}" />
</body>
</html>
