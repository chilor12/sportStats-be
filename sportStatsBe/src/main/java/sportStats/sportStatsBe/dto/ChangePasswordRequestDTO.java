package sportStats.sportStatsBe.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import lombok.Data;
import sportStats.sportStatsBe.constant.SportStatsError;

@Data
public class ChangePasswordRequestDTO {

	@NotNull(message = SportStatsError.OLD_PASSWORD_REQUIRED)
	@NotBlank(message = SportStatsError.OLD_PASSWORD_REQUIRED)
	private String oldPassword;
	
	@NotNull(message = SportStatsError.NEW_PASSWORD_REQUIRED)
	@NotBlank(message = SportStatsError.NEW_PASSWORD_REQUIRED)
	private String newPassword;
	
	@NotNull(message = SportStatsError.CONFIRM_PASSWORD_REQUIRED)
	@NotBlank(message = SportStatsError.CONFIRM_PASSWORD_REQUIRED)
	private String newPasswordConfirm;

	
}
