package sportStats.sportStatsBe.baseUtility;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Version;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import sportStats.sportStatsBe.utilities.MDCUtils;

@MappedSuperclass
@Data
@ToString
@EqualsAndHashCode
public class BaseEntity {

	@Column
	protected Boolean valid;

	@Version
	@Column(name = "rec_ver")
	protected Long recVer;

	@Column(name = "usr_ins")
	protected String usrIns;

	@Column(name = "usr_upd")
	protected String usrUpd;

	@Column(name = "dta_ins")
	protected Date dtaIns;

	@Column(name = "dta_upd")
	protected Date dtaUpd;

    @PrePersist
    public void onPrePersist() {
    	valid = true;
    	usrIns = MDCUtils.getUsername();
    	dtaIns = new Date();
    }

    @PreUpdate
    public void onPreUpdate() {
    	usrUpd = MDCUtils.getUsername();
    	dtaUpd = new Date();
    }

	
}
