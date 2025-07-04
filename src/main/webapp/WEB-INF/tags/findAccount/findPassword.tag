<%@ tag language="java" pageEncoding="UTF-8"%>

<div class="w-full flex flex-col justify-between">
	<div class="text-bold text-lg mb-4">비밀번호 찾기</div>
	<div class="w-full pl-2 mb-4">
		<input type="email" id="findName" name="findName" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="이름" required>
		<input type="email" id="findEmail" name="findEmail" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="사용자 ID" required>
		<input type="text" id="findPhone" name="findPhone" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="전화번호" required>
	</div>
	<span id="errorMessage" class="grow text-xs h-5 text-red-600 pl-2"></span>
	<button id="findIdSubmit" class="w-full px-10 py-3 outline-none bg-blue-3 rounded-full text-white text-lg hover:bg-blue-1">비밀번호 찾기</button>
</div>
<script type="text/javascript">
	$(document).ready(function () {
	    $("#findPhone").on("input", function () {
	        let number = $(this).val().replace(/[^0-9]/g, ""); // 숫자만 남기기
	
	        if (number.length < 4) {
	            $(this).val(number);
	        } else if (number.length < 7) {
	            $(this).val(number.slice(0, 3) + "-" + number.slice(3));
	        } else if (number.length < 11) {
	            $(this).val(number.slice(0, 3) + "-" + number.slice(3, 6) + "-" + number.slice(6));
	        } else {
	            $(this).val(number.slice(0, 3) + "-" + number.slice(3, 7) + "-" + number.slice(7, 11));
	        }
	    });
	});
	
	document.getElementById('findIdSubmit').addEventListener('click', function (e) {
		e.preventDefault();
		const error = document.getElementById('errorMessage');
		error.textContent = "";
		 
		const findName = document.getElementById('findName');
		const findEmail = document.getElementById('findEmail');
		const findPhone = document.getElementById('findPhone');
		
		if(findName.value === '') {
			findName.classList.remove("border-gray-5");
			findName.classList.add("border-red-600");
	    	
	    	error.textContent = "이름을 입력해야합니다.";
	    	return;
	    } else {
	    	findName.classList.remove("border-red-600");
	    	findName.classList.add("border-gray-5");
	    }
		
		if(findEmail.value === '') {
			findEmail.classList.remove("border-gray-5");
			findEmail.classList.add("border-red-600");
	    	
	    	error.textContent = "이름을 입력해야합니다.";
	    	return;
	    } else {
	    	findEmail.classList.remove("border-red-600");
	    	findEmail.classList.add("border-gray-5");
	    }
		
		if (findPhone.value === '') {
			findPhone.classList.remove("border-gray-5");
			findPhone.classList.add("border-red-600");
	    	
	    	error.textContent = "전화번호를 입력해야합니다.";
	    	return;
	    }  else {
	    	findPhone.classList.remove("border-red-600");
	    	findPhone.classList.add("border-gray-5");
	    }
		
		console.log("이름: ", findName.value);
		console.log("이메일: ", findEmail.value);
		console.log("전화번호: ", findPhone.value);
	});
</script>