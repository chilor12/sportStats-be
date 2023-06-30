package sportStats.sportStatsBe.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import sportStats.sportStatsBe.baseUtility.BaseEntity;
import sportStats.sportStatsBe.constant.DbNames;
import sportStats.sportStatsBe.constant.SequenceName;


@Entity
@Table(name = DbNames.USERS, schema = DbNames.SCHEMA)
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class User extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = SequenceName.SEQ_USERS)
	@SequenceGenerator(name = SequenceName.SEQ_USERS, allocationSize = 1)
	private Long id;

	@Column(name = "usr_name")
	private String username;

	@Column(name = "usr_mail")
	private String mail;

	@Column(name = "usr_pwd")
	private String password;

	@Column
	private String name;

	@Column
	private String surname;

	@Column(name = "sign_up_date")
	private Date signUpDate;

	
}
