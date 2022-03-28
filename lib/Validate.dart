class Validation{
	static bool isValidEmail(String input) {
		final RegExp regex = RegExp(
				r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
		return regex.hasMatch(input);
	}
	static bool isValidnull(String? input){
		if(input == "" || input == null || input.trim() == "" || input.trim() == null) return false;
		else return true;
	}
	static bool isValidPass(String input){
		if(input.length < 8 ||input.trim().length < 8) return false;else return true;
	}
	static bool isValidPassConf(String pass1,String pass2){
		if(pass1 != pass2) return false;else return true;
	}
}