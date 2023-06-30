package sportStats.sportStatsBe.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import lombok.Data;
import sportStats.sportStatsBe.constant.SportStatsError;


@Data
public class CreateSessionRequestDTO {

	@NotBlank(message = SportStatsError.USERNAME_REQUIRED)
	@NotNull(message = SportStatsError.USERNAME_REQUIRED)
	private String username;

	@NotBlank(message = SportStatsError.PASSWORD_REQUIRED)
	@NotNull(message = SportStatsError.PASSWORD_REQUIRED)
	private String password;
	
}
