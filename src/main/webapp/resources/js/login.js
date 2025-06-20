$('#loginForm').on('submit', function (e) {
    e.preventDefault(); // 기본 제출 막기

    const email = $('#email').val();
    const password = $('#password').val();
    
    $.ajax({
    	url: '/api/auth/login',
    	type: 'POST',
    	contentType: 'application/json',
    	data: JSON.stringify({ email, password }),
    	xhrFields: {
			withCredentials: true  // ✅ 쿠키 포함 허용
		},
    	success: function (response) {
        	// 토큰 저장
        	localStorage.setItem('accessToken', response.accessToken);
        	
        	alert(response.message);
        	
        	window.location.href = '/'; // 성공 시 이동
      	},
    	error: function (error) {
			let errorMessage = '로그인 실패';

	    	if (error.responseJSON && error.responseJSON.message) {
	        	errorMessage += ': ' + error.responseJSON.message;
	    	} else if (error.responseText) {
	        	errorMessage += ': ' + error.responseText;
	    	}
	
	    	alert(errorMessage);
		},
	});
});