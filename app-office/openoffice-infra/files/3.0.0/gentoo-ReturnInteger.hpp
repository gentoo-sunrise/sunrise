#ifndef INCLUDED_MSFORMS_RETURNINTEGER_HPP
#define INCLUDED_MSFORMS_RETURNINTEGER_HPP

#include "sal/config.h"

#include "ReturnInteger.hdl"

#include "com/sun/star/uno/Type.hxx"
#include "cppu/unotype.hxx"
#include "sal/types.h"
#include "typelib/typeclass.h"
#include "typelib/typedescription.h"

namespace msforms {

inline ReturnInteger::ReturnInteger() SAL_THROW( () )
    : Value(0)
{
}

inline ReturnInteger::ReturnInteger(const ::sal_Int32& Value_) SAL_THROW( () )
    : Value(Value_)
{
}

}

namespace msforms {

inline ::com::sun::star::uno::Type const & cppu_detail_getUnoType(::msforms::ReturnInteger const *) {
    //TODO: On certain platforms with weak memory models, the following code can result in some threads observing that the_type points to garbage
    static ::typelib_TypeDescriptionReference * the_type = 0;
    if (the_type == 0) {
        ::typelib_TypeDescriptionReference * the_members[] = {
            ::cppu::UnoType< ::sal_Int32 >::get().getTypeLibType() };
        ::typelib_static_struct_type_init(&the_type, "msforms.ReturnInteger", 0, 1, the_members, 0);
    }
    return *reinterpret_cast< ::com::sun::star::uno::Type * >(&the_type);
}

}

inline ::com::sun::star::uno::Type const & SAL_CALL getCppuType(::msforms::ReturnInteger const *) SAL_THROW(()) {
    return ::cppu::UnoType< ::msforms::ReturnInteger >::get();
}

#endif // INCLUDED_MSFORMS_RETURNINTEGER_HPP
