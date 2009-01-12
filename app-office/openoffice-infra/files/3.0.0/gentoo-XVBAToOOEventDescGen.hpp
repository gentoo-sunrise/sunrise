#ifndef INCLUDED_ORG_OPENOFFICE_VBA_XVBATOOOEVENTDESCGEN_HPP
#define INCLUDED_ORG_OPENOFFICE_VBA_XVBATOOOEVENTDESCGEN_HPP

#include "sal/config.h"

#include "XVBAToOOEventDescGen.hdl"

#include "com/sun/star/script/ScriptEventDescriptor.hpp"
#include "com/sun/star/script/XScriptEventsSupplier.hpp"
#include "com/sun/star/uno/RuntimeException.hpp"
#include "com/sun/star/uno/XInterface.hpp"
#include "com/sun/star/uno/Reference.hxx"
#include "com/sun/star/uno/Sequence.hxx"
#include "com/sun/star/uno/Type.hxx"
#include "cppu/unotype.hxx"
#include "osl/mutex.hxx"
#include "rtl/ustring.hxx"

namespace org { namespace openoffice { namespace vba {

inline ::com::sun::star::uno::Type const & cppu_detail_getUnoType(::org::openoffice::vba::XVBAToOOEventDescGen const *) {
    static typelib_TypeDescriptionReference * the_type = 0;
    if ( !the_type )
    {
        typelib_static_mi_interface_type_init( &the_type, "org.openoffice.vba.XVBAToOOEventDescGen", 0, 0 );
    }
    return * reinterpret_cast< ::com::sun::star::uno::Type * >( &the_type );
}

} } }

inline ::com::sun::star::uno::Type const & SAL_CALL getCppuType(::com::sun::star::uno::Reference< ::org::openoffice::vba::XVBAToOOEventDescGen > const *) SAL_THROW(()) {
    return ::cppu::UnoType< ::com::sun::star::uno::Reference< ::org::openoffice::vba::XVBAToOOEventDescGen > >::get();
}

::com::sun::star::uno::Type const & ::org::openoffice::vba::XVBAToOOEventDescGen::static_type(void *) {
    return ::getCppuType(static_cast< ::com::sun::star::uno::Reference< ::org::openoffice::vba::XVBAToOOEventDescGen > * >(0));
}

#endif // INCLUDED_ORG_OPENOFFICE_VBA_XVBATOOOEVENTDESCGEN_HPP
