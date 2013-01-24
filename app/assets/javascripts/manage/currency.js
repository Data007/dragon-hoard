/**
 * Object to currency manipulation.
 *
 * @author  Henrique Moody <henriquemoody@gmail.com>
 */
Currency  = {

    /**
     * The currency simbal
     *
     * @type {String}
     */
    simbal : '$',

    /**
     * Cents separator.
     *
     * @type {String}
     */
    centsSeparator : '.',

    /**
     * Thousands separator.
     *
     * @type {String}
     */
    thousandsSeparator : ',',

    /**
     * Turns a number into a currency string.
     *
     * Based on http://javascript.internet.com/forms/currency-format.html
     *
     * @author Cyanide_7 <leo7278@hotmail.com>
     * @param {Number} number
     * @return {String}
     */
    numberToCurrency : function (number)
    {
        if (this.isCurrency(number)) {
            return number;
        }
        if(isNaN(number))
            number = "0";
        var sign = (number == (number = Math.abs(number)));
        number = Math.floor(number*100+0.50000000001);
        var cents = number%100;
        number = Math.floor(number/100).toString();
        if(cents < 10)
            cents = "0" + cents;
        for (var i = 0; i < Math.floor((number.length-(1+i))/3); i++)
            number = number.substring(0,number.length-(4*i+3))+ this.thousandsSeparator+
            number.substring(number.length-(4*i+3));
        return (((sign)?'':'-') + this.simbal + number + this.centsSeparator + cents);
    },

    /**
     * Turns a currency string into a number.
     *
     * @param {String} currency
     * @return {Number}
     */
    currencyToNumber : function (currency)
    {
        if (!isNaN(currency)) {
            return currency;
        }
        currency    = currency.toString()
                              .replace(this.simbal, '')
                              .replace(this.thousandsSeparator, '', 'g')
                              .replace(this.centsSeparator, '.');
        return parseFloat(currency);
    },

    /**
     *  Checks if "currency" is a valid currency.
     *
     * @return {Boolean}
     */
    isCurrency : function (currency)
    {
        var simbal  = this.simbal.replace('\$', '\\$');
        var regex   = '^' + simbal +
                      '[0-9]{1,3}(([' + this.thousandsSeparator + '][0-9]{3})+)?' +
                      '[' +this.centsSeparator + '][0-9]{2}$';
        regex   = new RegExp(regex);
        return regex.test(currency);
    }

};

/**
 * Turns a number into a currency string.
 *
 * Allows transform any number into currency.
 * <pre>
 * var myNumber     = 2100.58;
 * var myCurrency   = myNumber.<b>toCurrency()</b>; <i>//$2,100.58</i>
 * </pre>
 * @return {String}
 */
Number.prototype.toCurrency = function ()
{
    return Currency.numberToCurrency(this);
};

/**
 * Checks if the string is a valid currency.
 *
 * Allows checks if any string is a valid currency.
 * 
 * <pre>
 * var myString     = "$1,159,654.00";
 * alert(myString.isCurrency());// true
 * </pre>
 * @return {String}
 */
String.prototype.isCurrency = function ()
{
    return Currency.isCurrency(this);
}
