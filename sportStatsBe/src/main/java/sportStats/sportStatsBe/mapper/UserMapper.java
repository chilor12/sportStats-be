package sportStats.sportStatsBe.mapper;

import fr.xebia.extras.selma.Maps;
import fr.xebia.extras.selma.Selma;
import sportStats.sportStatsBe.constant.MapperIgnoredFields;
import sportStats.sportStatsBe.dto.UserDTO;
import sportStats.sportStatsBe.entity.User;

public interface UserMapper {

	UserMapper INSTANCE = Selma.builder(UserMapper.class).build();
	
	@Maps(withIgnoreFields = MapperIgnoredFields.PASSWORD)
	UserDTO toDTO(User entity);
	
	@Maps
	User toEntity(UserDTO dto);
	
}
