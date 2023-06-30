package sportStats.sportStatsBe.exception;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SportStatsException extends RuntimeException {
	
	private static final long serialVersionUID = -5123813890849895490L;

	public SportStatsException(String msg, Throwable root) {
		super(msg,root);
	}
	
	public SportStatsException( Throwable root) {
		super(root);
	}
	
	public SportStatsException(String msg) {
		super(msg);
	}
	
}
