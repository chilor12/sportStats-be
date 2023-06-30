package sportStats.sportStatsBe.utilities;

import org.slf4j.MDC;

import sportStats.sportStatsBe.constant.MDCKeys;

public class MDCUtils {

	public static final String getUsername() {
		return MDC.get(MDCKeys.USERNAME);
	}
	
}
