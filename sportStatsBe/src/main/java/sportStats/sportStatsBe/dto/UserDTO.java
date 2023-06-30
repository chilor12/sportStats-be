package sportStats.sportStatsBe.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import lombok.Data;
import sportStats.sportStatsBe.constant.SportStatsError;

@Data
public class UserDTO {

	@NotNull(message = SportStatsError.NAME_REQUIRED)
	@NotBlank(message = SportStatsError.NAME_REQUIRED)
	private Long id;
	@NotNull(message = SportStatsError.SURNAME_REQUIRED)
	@NotBlank(message = SportStatsError.SURNAME_REQUIRED)
	private String name;
	@NotNull(message = SportStatsError.EMAIL_REQUIRED)
	@NotBlank(message = SportStatsError.EMAIL_REQUIRED)
	private String surname;
	@Email(message = SportStatsError.INVALID_EMAIL)
	private String mail;
	
}
