<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃"%>

<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout"%>

<%@ attribute name="pageName" required="true"%>
<%@ attribute name="bodyContent" fragment="true"%>
<%@ attribute name="headLink" fragment="true"%>
<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>${pageName}</title>
<link rel="stylesheet" href="${cpath}/resources/css/styles.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<c:if test="${pageType eq 'ingame'}">
  <link rel="stylesheet" href="${cpath}/resources/css/cointoss.css" />
  <link rel="stylesheet" href="${cpath}/resources/css/turtlerun.css" />
</c:if>
<link rel="stylesheet" href="${cpath}/resources/css/summernote/summernote-lite.css">
<jsp:invoke fragment="headLink"></jsp:invoke>
<script src="https://cdn.tailwindcss.com"></script>
<script type="text/javascript">
	$(document).ready(function () {
		let token = localStorage.getItem('accessToken');

		$.ajaxSetup({
			beforeSend: function (xhr) {
				if (token) {
					xhr.setRequestHeader("Authorization", "Bearer " + token);
				}
			},
			complete: function (xhr) {
				const newToken = xhr.getResponseHeader("New-Access-Token");
				if (newToken) {
					token = newToken.replace("Bearer ", "");
					localStorage.setItem("accessToken", token);
				}
			}
		});
	});

	tailwind.config = {
		    theme: {
		        extend: {
		            colors: {
		                'gray-1': '#D8D8D8',
		                'gray-2': '#E7E5E4',
		                'gray-3': '#828688',
		                'gray-4': '#F7F7F7',
		                'gray-5': '#D4D4D4',
		                'gray-6': '#757575',
		                'gray-7': '#656565',
		                'gray-8': '#F4F4F4',
		                'gray-9': '#A5A5A5',
		                'gray-10': '#EDEDED',
		                'blue-1': '#4A90E2',
		                'blue-2': '#3F7AB6',
		                'blue-3': '#A2C8E6',
		                'blue-4': '#D9E8F2',
		                'blue-5': '#1967B6',
		                'blue-6': '#D2E1EB',
		                'red-1': '#EC6F6F',
		            },
		            fontSize: {
		                'ts-28': ['1.75rem', { lineHeight: '100%', fontWeight: '800' }],
		                'ts-24': ['1.5rem', { lineHeight: '100%', fontWeight: '800' }],
		                'ts-20': ['1.25rem', { lineHeight: '100%', fontWeight: '800' }],
		                'ts-18': ['1rem', { lineHeight: '100%', fontWeight: '800' }],
		                'ts-14': ['0.75rem', { lineHeight: '100%', fontWeight: '800' }],
		            },
		            screens: {
		                'max-1350': { max: '1350px' },
		                'max-1300': { max: '1300px' },
		                'max-1250': { max: '1250px' },
		                'max-1200': { max: '1200px' },
		            },
		            keyframes: {
		                'bounce-custom': {
		                    '0%, 20%, 53%, 80%, 100%': { transform: 'translate3d(0,0,0)' },
		                    '40%, 43%': { transform: 'translate3d(0,-8px,0)' },
		                    '70%': { transform: 'translate3d(0,-4px,0)' },
		                    '90%': { transform: 'translate3d(0,-2px,0)' },
		                },
		                fadeInUp: {
		                    '0%': { opacity: '0', transform: 'translateY(10px)' },
		                    '100%': { opacity: '1', transform: 'translateY(0)' },
		                },
		            },
		            animation: {
		                'bounce-custom': 'bounce-custom 2s infinite',
		                fadeInUp: 'fadeInUp 0.3s ease-out',
		            },
		        },
		    },
		};
</script>
</head>
<body>
	<div class="min-h-screen flex flex-col">
		<layout:header pageType="${pageType}" />
		
		<main class="grow flex main-container">
			<jsp:invoke fragment="bodyContent" />
		</main>
		
		<layout:footer pageType="${pageType}" />
	</div>
</body>
</html>
