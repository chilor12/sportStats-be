package sportStats.sportStatsBe.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import sportStats.sportStatsBe.entity.User;

@Repository
public interface UserRepository extends CrudRepository<User, Long> {

	@Query("SELECT u FROM User u where u.username = :username "
								+ "and u.password = :password "
								+ "and u.valid = true")
	Optional<User> findByMailAndPasswordAndValid(@Param("username") String username, 
									   @Param("password") String password);
	
}
