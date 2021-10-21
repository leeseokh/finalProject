<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="/resources/js/jquery.min.js"></script>

<form id="frmSleepOutApp">
			<div style="display: none;">
				<!-- 기숙여부를 알기 위한 정보 -->
				<input type="text" id="stdId" <c:if test="${sessionScope.student == '01'}">value="${memberVo.memId}"</c:if>>
				<select id="year"></select>
				<select id="semCode">
					<c:forEach var="code" items="${semCode}">
						<option value="${code.codeVal}">${code.codeName}</option>
					</c:forEach>
				</select>
			</div>
</form>
				<!-- 여기서부터 전송영역 -->
<form id="frmSleepOutListInform">
			<div style="display: none;">
				<input type="text" id="roomIdnNum">
				<input type="text" id="entrApplyNum">
			</div>
</form>


<div class="card shadow">

	<div class="card-header">
		<h6 class="card-title m-0 font-weight-bold text-primary">외박신청 내역</h6>
	</div>

	<div class="card-body">

		<div class="row" style="margin-top: 20px;">
			<div class="col-12">
				<table class="table text-nowrap">
					<thead>
						<tr>
							<td>순번</td>
							<td>신청일자</td>
							<td>호실자리</td>
							<td>외박출발일자</td>
							<td>외박귀가일자</td>
							<td>행선지</td>
							<td>긴급연락처</td>
							<td>외박사유</td>
						</tr>
					</thead>
					<tbody id="test" style="text-align: center;"></tbody>
				</table>
			</div>
		</div>

		<hr>

		<div class="row">
			<div class="col-12">
				<div style="float: right;">
					<div class="form-group">
						<button type="button" class="btn btn-primary" id="btnInsert"
							style="width: 100px;"
							onclick="javascript:location.href='/student/dorm/sleepOut/sleepOutApply'">등록</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

	<script type="text/javascript">
	$(function(){
		
		//년도와 학기 값 자동으로 넣어서 disabled
		var now = new Date();
		console.log(now);
		var year = now.getFullYear();
		var yearVal = "";
		yearVal = "<option>" + year + "</option>"
	
		$("#year").html(yearVal);
		
		$("#applyDate").val(now.toISOString().substring(0, 10));
	
		var month = now.getMonth() + 1; //'월'은 0~11까지라서 +1해줘야함
	
		if (month >= 3 && month < 6) { // 1학기
			$("#semCode option:eq(0)").prop("selected", true);
		} else if (month >= 9 && month < 12) { //2학기
			$("#semCode option:eq(1)").prop("selected", true);
		} else if (month >= 6 && month < 9) { //여름학기
			$("#semCode option:eq(2)").prop("selected", true);
		} else { //겨울학기
			$("#semCode option:eq(3)").prop("selected", true);
		}
		
		var stdId =  $("#stdId").val();
		var year = $("#year option:selected").val();
		var semCode = $("#semCode option:selected").val();
		
		var json = {
				"stdId" : stdId,
				"year" : year,
				"semCode" : semCode
		}
		
		//조건 날리면 바로 조회되는 ajax
		$.ajax({
			url : "/student/dorm/sleepOut/sleepOutCondition",
			data : JSON.stringify(json),
			contentType: "application/json; charset=UTF-8", //보낼타입
			dataType : "json", //받을타입
			type : "POST",
			success : function(data){
				console.log(data);
				$("#roomIdnNum").val(data.roomIdnNum);
				$("#entrApplyNum").val(data.entrApplyNum);
				
				var roomIdnNum = $("#roomIdnNum").val();
				console.log(roomIdnNum);
				var entrApplyNum = $("#entrApplyNum").val();
				console.log(entrApplyNum);
				
				var json = {
						"roomIdnNum" : roomIdnNum,
						"entrApplyNum" : entrApplyNum
				}
				
				$.ajax({
					url : "/student/dorm/sleepOut/sleepOutList",
					data : JSON.stringify(json),
					contentType: "application/json; charset=UTF-8", //보낼타입
					dataType : "json", //받을타입
					type : "POST",
					success : function(data){
						
						console.log(data);
						if(data != []){
							temp(data);
						}else{
							nothing();
						}
					}
				});
			},
			error : function(xhr){
				alert("생활관 사생이 아닙니다.");
				$("#btnInsert").prop("disabled",true);
				nothing();
			}
		});
		
		
		
		
	});
	
	function temp(list) {
		var opts = "";

		$(list).each(function(idx, item) {
			
				opts += "<tr onclick='fn_Detail(this)' class='trClick'><td>"+ item.rnum + "</td>"
					 + "<td>"+ item.applyDate + "</td>"
					 + "<td>" + "</td>"
					 + "<td>"+ item.departDate + "</td>"
					 + "<td>"+ item.returnDate + "</td>"
					 + "<td>" + "</td>"
					 + "<td>"+ item.emrContact + "</td>"
					 + "<td>"+ item.slpOutRsn + "</td></tr>";
			
		});
		$("#test").html(opts);
	}
	
	
	function nothing(){
		var opts = "";
		opts += "<tr><td colspan='8' class='text-center'>신청 정보가 존재하지 않습니다.</td></tr>"
		$("#test").html(opts);
	}
	
	function fn_Detail(list){
		
		var roomIdnNum = document.getElementById('roomIdnNum').value;
		var entrApplyNum = document.getElementById('entrApplyNum').value;

		var tdList = $(list).children('td');
		var applyDate = tdList[1].innerHTML;
		
		console.log(applyDate);

		var change = '';
		
		change = applyDate.split("-").join("/");	//replaceAll처럼 활용하는 방법.
		console.log(change);
		
		location.href = '/student/dorm/sleepOut/sleepOutDetailList?roomIdnNum=' + roomIdnNum 
				+ '&entrApplyNum=' + entrApplyNum 
				+ '&applyDate=' + change;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</script>