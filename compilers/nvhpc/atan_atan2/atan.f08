program free_form
   x = 0.1; y = 0.7 ! Two small statements in one line
                    ! Comment with an exclamation mark

   val  = atan(y,x)
   val2 = atan2(y,x)
   !val  = val2

   print *, val, val2
end program free_form
